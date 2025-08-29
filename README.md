# Useage
M3 MACのローカル環境で動作確認を行なっています.<br />
実行環境に合わせDockerfile内のSelfHostedRunnerのインストールアーキテクチャを変更してください.

## 実行方法
```bash
> docker compose up -d
> docker compose exec runner bash

# 以下コンテナ内実行
> su runner
> ./config.sh --url https://github.com/${USER}/${REPOSITORY} --token ${TOKEN}
> ./run.sh
```
