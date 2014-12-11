class DrawRequestsController < ApplicationController

  def create
    @draw_request = DrawRequest.new game_id: Integer(params[:game_id]), requester: current_user.id
    partnership = Partnership.find_by_game_id(Integer(params[:game_id]))
    if partnership.user1_id == current_user.id ? @draw_request.requested = partnership.user2_id : @draw_request.requested = partnership.user1_id
    sent_to = User.find(@draw_request.requested).username
    end
    respond_to do |format|
      if @draw_request.save
        format.html { redirect_to game_url(params[:game_id]), notice: "You sent a draw request to #{sent_to}!" }
        format.json { render :show, status: :created, location: @type }
      else
        format.html { redirect_to game_url(params[:game_id]), notice: "Your request to #{sent_to} could not be sent!"}
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end

  end

  def accept
    @draw_request = DrawRequest.find_by id: Integer(params[:id])
    @draw_request.received = true
    @draw_request.game.end = Time.now
    @draw_request.game.save
    requested = User.find(@draw_request.requested)
    requested.score.nil? ? requested.score =  0.5 : requested.score +=  0.5
    requester = User.find(@draw_request.requester)
    requester.score.nil? ? requester.score =  0.5 : requester.score +=  0.5
    requester.save
    requested.save
    respond_to do |format|
      if @draw_request.save
        format.html {  redirect_to game_url(@draw_request.game_id), notice: "The game is drawn!" }
        format.json { render :show, status: :created, location: @type }
      else
        format.html {  redirect_to game_url(@draw_request.game_id), notice: "Your accept action could not be processed!" }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end

  def decline
    @draw_request = DrawRequest.find_by id: Integer(params[:id])
    @draw_request.received = true
    respond_to do |format|
      if @draw_request.save
        format.html { redirect_to game_url(@draw_request.game.id), notice: "You declined a draw request!" }
        format.json { render :show, status: :created, location: @type }
      else
        format.html { redirect_to game_url(@draw_request.game.id), notice: "Your decline action could not be processed!"  }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end
end
