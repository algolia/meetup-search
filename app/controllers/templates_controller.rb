class TemplatesController < ApplicationController

  caches_page :event, :events, :home

  layout false

end
