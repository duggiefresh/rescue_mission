import Ember from 'ember';

export default Ember.ObjectController.extend(Ember.Validations.Mixin, {
  isCommenting: false,
  isEditing: false,

  itemId: function() {
    return 'answer-' + this.get('id');
  }.property('id'),

  validations: {
    body: {
      length: { minimum: 30, maximum: 10000 }
    }
  },

  canBeAccepted: function() {
    var alreadyAccepted = this.get('isAcceptedAnswer');
    var userWroteQuestion = this.get('model.content._data.question.canEdit');

    if (!alreadyAccepted && userWroteQuestion) {
      return true;
    } else {
      return false;
    }
  }.property('isAcceptedAnswer', 'question'),

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

    accept: function(question) {
      var answer = this.get('model');
      var _this = this;

      answer.get('question').then(function(question){
        question.set('acceptedAnswer', answer);

        question.save().then(function() {
          alert("question was saved");
          _this.wuphf.success('Answer accepted!', 3000);
        }, function(){
          alert("question was not saved");
          _this.wuphf.danger('Something went wrong. Please try again.', 3000);
        });
      });
    },

    addComment: function() {
      this.set('isCommenting', true);
    }
  }
});
