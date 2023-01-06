# syntax=docker/dockerfile:1.3-labs
FROM node:17-buster-slim

ARG DEBIAN_FRONTEND=noninteractive
RUN bash <<EOF
apt update
apt install -y --no-install-recommends \
  build-essential python3
rm -rf /var/lib/apt/lists/*
EOF

RUN bash <<EOF
npm i -g npm@8.1.3
npm i -g rimraf shx glob
npm i -g --unsafe-perm=true --allow-root \
  @stacks/auth @stacks/storage @stacks/transactions @stacks/cli \
  @stacks/stacking @stacks/keychain @stacks/network @stacks/encryption \
  @stacks/profile @stacks/common @stacks/bns @stacks/wallet-sdk
EOF

COPY <<ENTRYPOINT /opt/entrypoint.sh
#!/usr/bin/env bash
#
export NODE_PATH=$(npm root --quiet -g)
case \$1 in
  cli) exec /usr/local/bin/stx \"\${@:2}\" || exit;;
  bash) exec /usr/bin/env bash \"\${@:2}\" || exit;;
  *)
    [[ -z \$1 ]] && { echo \"Missing first argument\"; exit 1; }
    exec usr/local/bin/node \"/app/\$1.js\" \"\${@:2}\" || exit
    ;;
esac
exit
ENTRYPOINT

RUN chmod 755 /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]