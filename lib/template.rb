class Template
  def self.load(template_path, key, value)
    action_view = ActionView::Base.new(Rails.root.join('app', 'views'))
    action_view.class_eval do
      define_method key do
        value
      end
    end
    action_view.render(:template => template_path)
  end
end
