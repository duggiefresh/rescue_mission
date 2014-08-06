import DS from 'ember-data';

export default DS.Model.extend({
  question: DS.belongsTo('question', {
    async: true,
    inverse: 'answers'
  }),
  user: DS.belongsTo('user', { async: true }),

  body: DS.attr('string'),
  canEdit: DS.attr('boolean', { defaultValue: false }),
  isAcceptedAnswer: DS.attr('boolean', { defaultValue: false })
});
