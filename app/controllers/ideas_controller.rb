class IdeasController < ApplicationController
  before_action :set_brainstorm, only: [:create]

  def create
    @idea = Idea.new(idea_params)
    respond_to do |format|
      if @idea.save
          ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-idea", content: @idea, ideas_total: @brainstorm.ideas.count, idea_number: @idea.number )
        format.js
      else
        @idea.errors.messages.each do |message|
          flash.now[message.first] = message[1].first
          format.js
        end
        format.js
      end
    end
  end

  private

  def idea_params
    params.require(:idea).permit(:text, :brainstorm_id)
  end

  def set_brainstorm
    @brainstorm = Brainstorm.find idea_params[:brainstorm_id]
  end
end
