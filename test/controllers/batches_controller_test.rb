require 'test_helper'

class BatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @batch = batches(:one)
  end

  test "should get index" do
    get batches_url, as: :json
    assert_response :success
  end

  test "should create batch" do
    assert_difference('Batch.count') do
      post batches_url, params: { batch: { purchase_channel: @batch.purchase_channel } }, as: :json
    end

    assert_response 201
  end

  test "should show batch" do
    get batch_url(@batch), as: :json
    assert_response :success
  end
end
