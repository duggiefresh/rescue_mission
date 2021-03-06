import DS from 'ember-data';
import Commentable from './commentable';

export default Commentable.extend({
  user: DS.belongsTo('user', { async: true }),
  answers: DS.hasMany('answer', { async: true }),

  body: DS.attr('string'),
  canEdit: DS.attr('boolean', { defaultValue: false }),
  title: DS.attr('string'),
});
