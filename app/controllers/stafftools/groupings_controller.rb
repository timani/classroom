# frozen_string_literal: true
module Stafftools
  class GroupingsController < StafftoolsController
    def show
    end

    private

    def grouping
      @grouping ||= Grouping.includes(:organization, :groups).find_by!(id: params[:id])
    end
    helper_method :grouping
  end
end
