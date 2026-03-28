FROM scratch

COPY --from=nr-agent-builder:local /usr/src/newrelic-php-agent/agent/modules/newrelic.so /newrelic.so
COPY --from=nr-agent-builder:local /usr/src/newrelic-php-agent/bin/daemon /newrelic-daemon
