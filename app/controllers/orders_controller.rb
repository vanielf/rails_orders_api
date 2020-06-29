class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update]

  # GET /orders
  def index
    filter = params.permit(:purchase_channel, :client_name, :delivery_service, :total_value, :status)

    if filter
      @orders = Order.where(filter)
    else
      @orders = Order.all
    end

    @orders = @orders.page(params[:page])
    render json: {
      result: @orders,
      current_page: @orders.current_page,
      total_pages: @orders.total_pages
    }, :except => [:id, :batch_id]
  end

  # GET /orders/1
  def show
    render json: @order, :except => [:id, :batch_id]
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    @order.status = "ready"

    if @order.save
      render json: @order, status: :created, location: @order, :except => [:id, :batch_id]
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /orders/1
  def update
    if @order.update(params.require(:order).permit(:client_name, :address, :line_items))
      render json: @order, status: :created, location: @order, :except => [:id, :batch_id]
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # GET /orders/financial_report
  def financial_report
    @report = Order.select("purchase_channel, COUNT(*) as orders, SUM(total_value) as total_value").group("purchase_channel")
    @report = @report.map{|result| [result["purchase_channel"], {orders: result["orders"], total_value: result["total_value"]}]}
    render json: @report.to_h, :except => [:id]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find_by!(reference: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:reference)
      params.require(:purchase_channel)
      params.require(:client_name)
      params.require(:address)
      params.require(:delivery_service)
      params.require(:total_value)
      params.require(:line_items)

      params.require(:order).permit(:reference, :purchase_channel, :client_name, :address, :delivery_service, :total_value, {line_items: params[:line_items].map(&:keys)})
    end
end
