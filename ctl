#!/usr/bin/env bash
[ ${BASH_VERSION%%.*} -lt 4 ] && { echo "Requires bash 4+"; exit 1; }

set -e

Target="$1"
Action="$2"
Service="$3"

[[ -z $Target ]] && {
  echo "usage: ./ctl <target:host[local]> <action:compose|...> [service] ..."
  exit 1
}

[[ ! $Target = "local" ]] && export DOCKER_HOST="ssh://$Target"

case "$Action" in

  'compose')
    ServiceFile="services/$Service/docker-compose.yml"
    [[ ! -r $ServiceFile ]] && {
      docker compose ${@:3}
      exit
    }

    EnvFile="services/$Service/.env"
    [[ -r $EnvFile ]] \
      && EnvFile="--env-file $EnvFile" \
      || EnvFile=""

    docker compose $EnvFile -f $ServiceFile ${@:4}
    ;;

  'stack')
    ServiceFile="stacks/$Service/docker-compose.yml"
    [[ ! -r $ServiceFile ]] && {
      docker stack ${@:3}
      exit
    }

    case "$4" in

      'deploy')
        EnvFile="stacks/$Service/.env"
        [[ -r $EnvFile ]] && {
          set -o allexport
          . $EnvFile
          set +o allexport
        }
        #docker stack deploy --prune -c <(echo -e "version: '3.9'\n"; docker compose $EnvFile -f $ServiceFile config) $Service
        docker stack deploy --prune -c $ServiceFile $Service
        ;;

      'ps') docker stack ps --no-trunc ${@:5} $Service;;

      *) docker stack ${@:4} $Service;;
    esac
    ;;

  *) docker ${@:2};;

esac

exit