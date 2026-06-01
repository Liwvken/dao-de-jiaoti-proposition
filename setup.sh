#!/bin/bash
# 道德与法治命题工具包 - 一键安装脚本
# 使用方法：bash setup.sh
# 使用符号链接，试题库修改自动对应 git 仓库，方便双向同步

set -e

echo "========================================="
echo "  道德与法治命题工具包 安装脚本"
echo "========================================="
echo ""

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$HOME/.claude/skills"
MEMORY_DIR="$HOME/.claude/memory"

# 1. 安装技能（符号链接）
echo "[1/4] 安装技能到 $SKILL_DIR ..."
for skill in objective-question subjective-question scenario-judgment question-bank-manager; do
    # 删除旧版本（可能是之前 cp 的副本或旧链接）
    if [ -d "$SKILL_DIR/$skill" ] || [ -L "$SKILL_DIR/$skill" ]; then
        rm -rf "$SKILL_DIR/$skill"
        echo "  🔄 已移除旧版 $skill，重新链接"
    fi
    ln -s "$REPO_DIR/skills/$skill" "$SKILL_DIR/$skill"
    echo "  ✓ $skill 链接完成"
done

# 2. 安装记忆参考文件（符号链接）
echo "[2/4] 安装参考文件到 $MEMORY_DIR ..."
mkdir -p "$MEMORY_DIR"

# 命题总要求
if [ -f "$MEMORY_DIR/proposition-general-requirements.md" ] && [ ! -L "$MEMORY_DIR/proposition-general-requirements.md" ]; then
    rm "$MEMORY_DIR/proposition-general-requirements.md"
fi
ln -sf "$REPO_DIR/memory/proposition-general-requirements.md" "$MEMORY_DIR/"

# 教材框架文件
for textbook in textbook-7a.md textbook-7b.md textbook-8a.md textbook-8b.md textbook-xi-reader.md; do
    if [ -f "$MEMORY_DIR/$textbook" ] && [ ! -L "$MEMORY_DIR/$textbook" ]; then
        rm "$MEMORY_DIR/$textbook"
    fi
    ln -sf "$REPO_DIR/memory/$textbook" "$MEMORY_DIR/"
done
echo "  ✓ 参考文件链接完成"

# 3. 安装试题库（符号链接整个目录）
echo "[3/4] 安装试题库（双向同步模式）..."
# 如果记忆目录已有试题库但不是链接，先备份
if [ -d "$MEMORY_DIR/question-bank" ] && [ ! -L "$MEMORY_DIR/question-bank" ]; then
    BACKUP_DIR="$MEMORY_DIR/question-bank-backup-$(date +%Y%m%d)"
    mv "$MEMORY_DIR/question-bank" "$BACKUP_DIR"
    echo "  ⚠ 旧试题库已备份到 $BACKUP_DIR"
fi
if [ -L "$MEMORY_DIR/question-bank" ]; then
    rm "$MEMORY_DIR/question-bank"
fi
ln -s "$REPO_DIR/memory/question-bank" "$MEMORY_DIR/question-bank"
echo "  ✓ 试题库链接完成（双向同步：git pull = 题库更新）"

# 4. 完成
echo "[4/4] 安装完成！"
echo ""
echo "  ✅ 技能：已链接到 $SKILL_DIR/"
echo "  ✅ 教材框架：已链接到 $MEMORY_DIR/"
echo "  ✅ 试题库：已链接到 $MEMORY_DIR/question-bank/"
echo ""
echo "  重启 Claude Code 或输入 /reload-plugins 生效。"
echo ""
echo "  📌 重要提示："
echo "    - 你存的新题自动保存在 git 仓库里"
echo "    - git pull 获取最新试题 → 记忆目录立刻同步"
echo "    - git add + commit + push 把你的题分享出去"
echo ""
echo "  如需贡献试题给题库，请在 $REPO_DIR 目录下操作 git。"
