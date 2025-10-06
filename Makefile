PID ?= .next-dev.pid
LOG ?= .next-dev.log

# Make sure those targets are commands not files
.PHONY: deps start stop logs

# Install node modules if needed
deps:
	@if [ ! -d ./node_modules ]; then \
		echo "📦 installing dependencies …"; \
		npm install; \
	else \
		echo "📦 dependencies OK"; \
	fi

# Start the server on localhost:3000 (headless)
start: deps stop
	@nohup ./node_modules/.bin/next dev > "$(LOG)" 2>&1 < /dev/null & echo $$! > "$(PID)"; \
	echo "✅ started (pid $$(cat $(PID))) — logs: $(LOG)"

# Stop the server
stop:
	@if [ -f "$(PID)" ]; then \
		kill $$(cat "$(PID)") 2>/dev/null || true; \
		rm -f "$(PID)"; \
	fi; \
	echo "🛑 stopped"

# See the server logs
logs:
	@touch "$(LOG)"; tail -f "$(LOG)"
