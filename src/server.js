const { Model } = require('objection');
const Knex = require('knex');

// Initialize knex.
const knex = Knex({
  client: 'sqlite3',
  useNullAsDefault: true,
  connection: {
    filename: 'DB.db'
  }
});

// Give the knex instance to objection.
Model.knex(knex);

class BaseShortTermTable extends Model {
  static filename
}
