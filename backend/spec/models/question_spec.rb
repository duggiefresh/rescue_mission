require 'rails_helper'

describe Question do
  describe "associations" do
    it { should belong_to :user }
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:accepted_answer).class_name('Answer') }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe "validations" do
    it { should ensure_length_of(:body).is_at_least(30).is_at_most(10000) }
    it { should ensure_length_of(:title).is_at_least(15).is_at_most(150) }
    it { should validate_presence_of(:user) }

    it "should allow an accepted answer that belongs to the right question" do
      answer = FactoryGirl.build_stubbed(:answer)
      question = answer.question
      question.accepted_answer = answer

      expect(question).to be_valid
    end

    it "should not allow an accepted answer if it belongs to a different question" do
      answer = FactoryGirl.build_stubbed(:answer)
      question = FactoryGirl.build_stubbed(:question)
      question.accepted_answer = answer

      expect(question).to_not be_valid
      expect(question.errors.full_messages).to include "Accepted answer must be in response to this question"
    end
  end
end
