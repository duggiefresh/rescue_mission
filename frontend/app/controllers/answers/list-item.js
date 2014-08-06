import Ember from 'ember';

export default Ember.ObjectController.extend(Ember.Validations.Mixin, {
  isEditing: false,
  itemId: function() {
    return 'answer-' + this.get('id');
  }.property('id'),

  validations: {
    body: {
      length: { minimum: 30, maximum: 10000 }
    }
  },

  actions: {
    edit: function() {
      this.set('isEditing', true);
    },

    cancel: function() {
      this.get('model').rollback();
      this.set('isEditing', false);
    },

    save: function() {
      var answer = this.get('model');
      var _this = this;

      answer.save().then(function() {
        _this.set('isEditing', false);
      }, function() {
        _this.wuphf.danger('Something went wrong. Please try again.', 3000);
      });
    },

    accept: function() {
      var answer = this.get('model');
      var question = answer.get('question.content');
      var _this = this;

      question.set('acceptedAnswer', answer);

      question.save().then(function() {
        _this.wuphf.success('Answer accepted!', 3000);
      }, function(){
        _this.wuphf.danger('Something went wrong. Please try again.', 3000);
      });
    }
  }
});
