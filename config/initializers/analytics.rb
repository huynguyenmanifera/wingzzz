if Wingzzz.config.google_tag_manager_container_id.present?
  Rails.application.config.middleware.use(Rack::Tracker) do
    handler :google_tag_manager,
            {
              # NOTE: Explicitly not using turbolinks: true here, since that doesn't seem to work properly.
              # Instead, a Turbolinks handler that pushes 'pageView' events is setup manually in app.ts.
              container: Wingzzz.config.google_tag_manager_container_id
            }
  end
end
