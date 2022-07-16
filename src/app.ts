import express, { Request, Response, NextFunction } from 'express';
import { Pool } from 'pg';
import { faker } from '@faker-js/faker';
import logger from './logger';

faker.locale = 'pt_BR';

const app = express();

const config = {
  host: process.env.HOST_DB,
  user: process.env.USER_DB,
  password: process.env.PASS_DB,
  database: 'people',
};

const pool = new Pool(config);

interface Results {
  name: string;
}

app.use(express.json());

app.use((request: Request, response: Response, nextFunction: NextFunction) => {
  if (request.path !== '/healthz') {
    logger.info(`Request ${request.method} ${request.path}`, {
      params: request.params,
      body: request.body,
      query: request.query,
      header: request.header,
    });
  }
  nextFunction();
});

app.get('/', async (req: Request, res: Response) => {
  const name = faker.name.firstName();

  const client = await pool.connect();

  const sqlInsert = `INSERT INTO people(name) values('${name}')`;
  const sqlSelect = 'SELECT name FROM people';

  try {
    await client.query(sqlInsert);
    const people = await client.query<Results>(sqlSelect);
    const names = people.rows.reduce(
      (prev, current) => `${prev}<li>${current.name}</li>`,
      ''
    );
    res.send(`<h1>Names</h1><ul>${names}</ul>`);
  } catch (error) {
    res.status(400).send(`Error: ${error}`);
  } finally {
    client.release();
  }
});

app.get('/healthz', (req: Request, res: Response) => {
  res.send({ msg: 'OK' });
});

export default app;
