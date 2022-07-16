import winston from 'winston';
import ecsFormat from '@elastic/ecs-winston-format';

const logger = winston.createLogger({
  format: ecsFormat(),
  transports: [new winston.transports.Console()],
});

export default logger;
