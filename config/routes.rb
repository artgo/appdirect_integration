AppdirectIntegration::Engine.routes.draw do
  match '/appdirect/api/order' => 'appdirect_integration/appdirect_callbacks#order', via: [:get]
  match '/appdirect/api/change' => 'appdirect_integration/appdirect_callbacks#change', via: [:get]
  match '/appdirect/api/cancel' => 'appdirect_integration/appdirect_callbacks#cancel', via: [:get]
  match '/appdirect/api/status' => 'appdirect_integration/appdirect_callbacks#status', via: [:get]
end