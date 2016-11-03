Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :github,
    Rails.application.secrets.github_client_id,
    Rails.application.secrets.github_client_secret,
    scope: %w(repo admin:org admin:org_hook user:email delete_repo).join(',')
  )
end
