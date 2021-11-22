require 'rails'
require 'administrate/field/text'
require 'administrate/engine'

# Needed because the gem that provides the field has a bug by default that prevents the saving of the book with keywords ( permitted_attribute needs to have 2 arguments )

module Administrate
  module Field
    class ActsAsTaggable < Administrate::Field::Text
      class Engine < ::Rails::Engine
        if defined?(Administrate::Engine)
          Administrate::Engine.add_javascript 'administrate-field-taggable/application'
          Administrate::Engine.add_stylesheet 'administrate-field-taggable/application'
        end
      end

      def context
        options.fetch(:context, @attribute)
      end

      def attribute
        context = super.to_s.singularize
        "#{context}_list"
      end

      # Added second argument to fix error | Github issue: https://github.com/apsislabs/administrate-field-acts_as_taggable/issues/5
      def self.permitted_attribute(attr, sec)
        context = super.to_s.singularize
        "#{context}_list"
      end

      def tags
        data
      end

      def name
        context.to_s
      end

      def delimitted
        tags.join(', ').to_s
      end

      def truncate
        delimitted.to_s[0...truncation_length]
      end

      def tag_options
        return [] unless defined?(ActsAsTaggableOn::Tag)

        ActsAsTaggableOn::Tag.for_context(context).order(:name).map do |t|
          { text: t.name, value: t.name }
        end
      end
    end
  end
end
