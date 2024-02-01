# frozen_string_literal: true

module FoxTail
  # Stimulus Controlled Concern
  module Controllable
    extend ActiveSupport::Concern

    included do
      delegate :stimulus_controller, :stimulus_controller_identifier, :use_stimulus?, :stimulus_merger, to: :class
    end

    def before_render
      super

      stimulus_controller.merge! html_attributes, stimulus_controller_options if use_stimulus?
    end

    def stimulus_controller_options
      raise NotImplementedError
    end

    class_methods do
      def stimulus_controller
        @stimulus_controller ||= find_stimulus_controller!
      end

      def stimulus_controller_identifier
        :"fox_tail--#{stimulus_controller_name.to_s.gsub("_", "-")}"
      end

      def stimulus_controller_name
        name.demodulize.underscore.gsub(/_component$/, "").to_sym
      end

      private

      def find_stimulus_controller!
        find_stimulus_controller(self) ||
          raise(FoxTail::ControllerNotImplemented, "Stimulus controller for #{name} not defined.")
      end

      def find_stimulus_controller(klass)
        if defined? klass::StimulusController
          klass::StimulusController.new stimulus_controller_identifier
        elsif klass != FoxTail::Base
          find_stimulus_controller klass.superclass
        end
      end
    end
  end
end
