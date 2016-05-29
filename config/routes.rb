Rails.application.routes.draw do
  root to: 'pages#home'
  post '/get_similiarity', to: 'pages#get_similiarity'
  get '/plagiarism_result', to: 'pages#plagiarism_result'
end
