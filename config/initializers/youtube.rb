# frozen_string_literal: true
Yt.configure do |config|
  config.api_key = ENV['YT_API_KEY']
  config.log_level = :debug
end

module GitHubClassroom
  def self.youtube_video_ids
    return @youtube_video_ids if defined?(@youtube_video_ids)
    yaml_file = YAML.load(File.read(Rails.root.join('config', 'youtube.yml')))
    @youtube_video_ids = HashWithIndifferentAccess.new(yaml_file)['videos']
  end
end
