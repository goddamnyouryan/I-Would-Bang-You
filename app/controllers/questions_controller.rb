class QuestionsController < ApplicationController
  def edit
    @user = User.find params[:user_id]
    @question = Question.find params[:id]
    respond_to do |format|
      format.js
    end
  end

  def update
    @user = User.find params[:user_id]
    @question = Question.find params[:id]
    if params[:answer]
      if params[:answer].blank?
        params[:answer] = nil
      end
      @question.update_attributes(:answer => params[:answer])
    end
    respond_to do |format|
      format.js
    end
  end

end
