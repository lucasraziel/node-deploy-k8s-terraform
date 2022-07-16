import app from './app';

const port = process.env.PORT || 3000;

app.listen(port, () => {
  // eslint-disable-next-line no-console
  console.log(`Rodando na porta ${port}`);
});
