require 'rails_helper'

describe AnswerSerializer do
  describe "#can_edit" do
    it "is true when current user created the answer" do
      answer = FactoryGirl.build_stubbed(:answer)
      current_user = answer.user

      serializer = AnswerSerializer.new(answer, scope: current_user)

      expect(serializer.can_edit).to eq true
    end

    it "is false when another user created the answer" do
      answer = FactoryGirl.build_stubbed(:answer)
      current_user = FactoryGirl.build_stubbed(:user)

      serializer = AnswerSerializer.new(answer, scope: current_user)

      expect(serializer.can_edit).to eq false
    end
  end

  describe "#is_accepted_answer" do
    it "is true when answer is the question's accepted answer" do
      question = FactoryGirl.create(:question, :with_accepted_answer)
      answer = question.accepted_answer

      serializer = AnswerSerializer.new(answer)

      expect(serializer.is_accepted_answer).to eq true
    end

    it "is false when answer is not the question's accepted answer" do
      question = FactoryGirl.create(:question)
      answer = FactoryGirl.create(:answer, question: question)

      serializer = AnswerSerializer.new(answer)

      expect(serializer.is_accepted_answer).to eq false
    end
  end
end
