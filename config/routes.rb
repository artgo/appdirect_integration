Rails.application.routes.draw do
  match 'appdirect/api/order' => 'appdirect_integration/appdirect_callbacks#order'
  match 'appdirect/api/change' => 'appdirect_integration/appdirect_callbacks#change'
  match 'appdirect/api/cancel' => 'appdirect_integration/appdirect_callbacks#cancel'
  match 'appdirect/api/status' => 'appdirect_integration/appdirect_callbacks#status'
end