require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get orders_url, as: :json
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post orders_url, params: { order: { address: @order.address, client_name: @order.client_name, delivery_service: @order.delivery_service, line_items: @order.line_items, purchase_channel: @order.purchase_channel, reference: @order.reference, status: @order.status, total_value: @order.total_value } }, as: :json
    end

    assert_response 201
  end

  test "should show order" do
    get order_url(@order), as: :json
    assert_response :success
  end

  test "should update order" do
    patch order_url(@order), params: { order: { client_name: @order.client_name } }, as: :json
    assert_response 200
  end
end
