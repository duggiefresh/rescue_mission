import Ember from 'ember';

export default Ember.ArrayController.extend({
  itemController: 'answers/list-item',

  unselectedAnswers: function() {
    return this.get('model').filterProperty('isAcceptedAnswer', false);
  }.property('model.@each.isAcceptedAnswer'),
});
