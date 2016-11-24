# frozen_string_literal: true
class YouTubeVideo
  attr_reader :id

  def initialize(id:)
    @id = id
  end

  def title
    return @video_title if defined?(@video_title)
    @video_title = Yt::Video.new(id: @id).title
  end

  def description
    return @video_description if defined?(@video_description)
    @video_description = Yt::Video.new(id: @id).description
  end
end
