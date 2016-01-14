module GrapeRouteHelpers
  # methods to extend Grape::API's behavior so it can get a
  # list of routes from all APIs and decorate them with
  # the DecoratedRoute class
  module AllRoutes
    def decorated_routes
      # memoize so that construction of decorated routes happens once
      @decorated_routes ||= all_routes.map { |r| DecoratedRoute.new(r) }
    end

    def all_routes
      routes = subclasses.flat_map { |s| s.send(:prepare_routes) }
      # delete duplicate routes
      routes.uniq do |route|
        route.instance_variable_get(:@options)
      end
    end
  end
end
