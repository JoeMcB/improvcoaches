# Compatibility shim so Administrate (Kaminari-style pagination)
# works alongside will_paginate used by the main app.

if defined?(WillPaginate)
  begin
    require 'will_paginate/active_record'
  rescue LoadError
    # ignore if not available; compat will attach if AR extension is present
  end
  # Extend AR relations that will_paginate decorates to support `.per` and `.total_count`
  module WillPaginate
    module ActiveRecord
      module RelationMethods
        # `.per(n)` like Kaminari. When no arg, return current per-page size.
        def per(value = nil)
          if value
            self.per_page = value
            self
          else
            per_page
          end
        end

        # Kaminari expects `.total_count` on paginated collections
        def total_count
          count
        end
      end
    end

    # Also ensure the collection object responds the same way
    class Collection
      def per(value = nil)
        if value
          self.per_page = value
          self
        else
          per_page
        end
      end

      def total_count
        total_entries
      end
    end
  end
end
