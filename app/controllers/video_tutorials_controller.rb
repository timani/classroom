# frozen_string_literal: true
class VideoTutorialsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @youtube_videos = GitHubClassroom.youtube_video_ids.map do |youtube_videos_id|
      YouTubeVideo.new(id: youtube_videos_id)
    end
  end
end
