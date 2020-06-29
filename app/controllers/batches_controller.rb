class BatchesController < ApplicationController
  before_action :set_batch, only: [:close, :sent]

  # POST /batches
  def create
    purchase_channel = params.require(:purchase_channel)

    orders = Order.where(
      purchase_channel: purchase_channel,
      status: "ready",
    ).count

    if orders > 0
      @batch = Batch.new(purchase_channel: purchase_channel)
      if @batch.save
        orders = Order.where(
          purchase_channel: purchase_channel,
          status: "ready",
        ).update_all(
          batch_id: @batch.id,
          status: "production",
        )

        render json: {
          reference: @batch.reference,
          purchase_channel: @batch.purchase_channel,
          orders: orders,
        }, status: :created, location: @batch
      else
        render json: @batch.errors, status: :unprocessable_entity
      end
    else
      render json: {
        error:"No orders ready for purchase channel \"#{purchase_channel}\"",
      }, status: :unprocessable_entity
    end
  end

  # PATCH /batches/1/close
  def close
    is_production = Order.where(
      batch_id: @batch.id,
      status: "production",
    ).count > 0

    if is_production
      orders = Order.where(
        batch_id: @batch.id,
      ).update_all(
        status: "closing",
      )

      render json: { orders: orders }
    else
      render json: {error:"Batch is not in production state"}, status: :unprocessable_entity
    end
  end

  # PATCH /batches/1/sent
  def sent
    delivery_service = params.require(:delivery_service)

    is_closed = Order.where(
      batch_id: @batch.id,
      delivery_service: delivery_service,
      status: "closing",
    ).count > 0

    if is_closed
      orders = Order.where(
        batch_id: @batch.id,
        delivery_service: delivery_service,
      ).update_all(
        status: "sent",
      )

      render json: { orders: orders }
    else
      render json: {error:"Batch is not in closing state"}, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = Batch.find_by!(reference: params[:id])
    end
end
