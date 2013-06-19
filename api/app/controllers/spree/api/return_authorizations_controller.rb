module Spree
  module Api
    class ReturnAuthorizationsController < Spree::Api::BaseController

      def create
        authorize! :create, ReturnAuthorization
        @return_authorization = order.return_authorizations.build(params[:return_authorization], :as => :api)
        if @return_authorization.save
          respond_with(@return_authorization, :status => 201, :default_template => :show)
        else
          invalid_resource!(@return_authorization)
        end
      end

      def destroy
        @return_authorization = order.return_authorizations.accessible_by(current_ability, :destroy).find(params[:id])
        @return_authorization.destroy
        respond_with(@return_authorization, :status => 204)
      end

      def index
        authorize! :admin, ReturnAuthorization
        @return_authorizations = order.return_authorizations.accessible_by(current_ability, :read).
                                 ransack(params[:q]).result.
                                 page(params[:page]).per(params[:per_page])
        respond_with(@return_authorizations)
      end

      def new
        authorize! :admin, ReturnAuthorization
      end

      def show
        authorize! :admin, ReturnAuthorization
        @return_authorization = order.return_authorizations.accessible_by(current_ability, :read).find(params[:id])
        respond_with(@return_authorization)
      end

      def update
        @return_authorization = order.return_authorizations.accessible_by(current_ability, :update).find(params[:id])
        if @return_authorization.update_attributes(params[:return_authorization])
          respond_with(@return_authorization, :default_template => :show)
        else
          invalid_resource!(@return_authorization)
        end
      end

      private

      def order
        @order ||= Order.find_by_number!(params[:order_id])
        authorize! :read, @order
      end

    end
  end
end
