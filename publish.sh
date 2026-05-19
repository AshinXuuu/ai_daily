#!/usr/bin/env bash
# 信号 / Signal 日报 · 一键发布脚本
#
# 用法：
#   ./publish.sh           # 自动发布今天最新的一期（按 manifest_NNN_snippet.json 编号最大的那期）
#   ./publish.sh 015       # 指定发布第 015 期
#
# 干的事：
#   1. 找到 manifest_NNN_snippet.json，把它合并到 daily/manifest.json 的 issues 数组顶部（去重，已存在则覆盖）
#   2. 检查对应的 daily/ai_daily_YYYY_MM_DD.html 是否存在
#   3. git add → commit → push 到远端
#
# 首次配置（仅一次性）：
#   cd ~/Desktop/日报/AI日报/AI新闻日报
#   git init
#   git remote add origin git@github.com:<你的用户名>/<仓库名>.git
#   git branch -M main
#   ./publish.sh                 # 第一次会自动 add 所有历史文件
#
# 如果用 HTTPS：把 origin 换成 https://github.com/<你的用户名>/<仓库名>.git

set -e
cd "$(dirname "$0")"

ROOT="$PWD"
MASTER="$ROOT/daily/manifest.json"

# 1. 找要发的那期编号
if [ -n "$1" ]; then
  ISSUE=$(printf "%03d" "$1")
else
  # 选 manifest_NNN_snippet.json 里编号最大的
  ISSUE=$(ls manifest_*_snippet.json 2>/dev/null | sed -E 's/manifest_([0-9]+)_snippet.json/\1/' | sort -n | tail -1)
fi

SNIPPET="$ROOT/manifest_${ISSUE}_snippet.json"

if [ ! -f "$SNIPPET" ]; then
  echo "❌ 找不到 $SNIPPET" && exit 1
fi

# 2. 从 snippet 里读 date 和 file，验证 HTML 存在
DATE=$(python3 -c "import json,sys; d=json.loads(open('$SNIPPET').read().rstrip(',\n ')); print(d['date'])")
FILE=$(python3 -c "import json,sys; d=json.loads(open('$SNIPPET').read().rstrip(',\n ')); print(d['file'])")
HTML="$ROOT/daily/$FILE"

if [ ! -f "$HTML" ]; then
  echo "❌ 找不到 HTML: $HTML" && exit 1
fi

echo "📰 准备发布第 ${ISSUE} 期 · ${DATE} · ${FILE}"

# 3. 把 snippet 对象 unshift 到 master manifest 的 issues 数组顶部（已存在则覆盖）
python3 - "$MASTER" "$SNIPPET" "$ISSUE" <<'PY'
import json, sys
master_path, snippet_path, issue_num = sys.argv[1], sys.argv[2], sys.argv[3]
master = json.loads(open(master_path).read())
snippet = json.loads(open(snippet_path).read().rstrip(',\n '))
# 去重：如果已经有同期号，覆盖；否则插到最前
master['issues'] = [i for i in master['issues'] if i.get('issue') != issue_num]
master['issues'].insert(0, snippet)
with open(master_path, 'w', encoding='utf-8') as f:
    json.dump(master, f, ensure_ascii=False, indent=2)
print(f"✅ 已合并第 {issue_num} 期到 daily/manifest.json 顶部")
PY

# 4. 如果还没初始化 git，提示用户先配
if [ ! -d "$ROOT/.git" ]; then
  cat <<EOF

⚠️  这个目录还不是 git 仓库 — 需要先一次性配置：

    cd "$ROOT"
    git init
    git remote add origin git@github.com:<你的用户名>/<仓库名>.git
    git branch -M main

配置完再跑一次 ./publish.sh 就行。

EOF
  exit 0
fi

# 5. git add / commit / push
git add daily/manifest.json "daily/$FILE" "manifest_${ISSUE}_snippet.json" 2>/dev/null || true
git add -A   # 兜底，把 README 等改动也带上

if git diff --cached --quiet; then
  echo "ℹ️  没有改动需要提交"
  exit 0
fi

COMMIT_MSG="📰 第 ${ISSUE} 期 · ${DATE}"
git commit -m "$COMMIT_MSG"

# 如果远端不存在就只提交不推
if git remote get-url origin >/dev/null 2>&1; then
  echo "🚀 推送到 GitHub..."
  git push -u origin HEAD
  echo "✅ 完成。Vercel 会自动重新部署。"
else
  echo "⚠️  没有配置 origin 远端，本地已 commit。"
fi
