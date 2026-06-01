#!/bin/bash
# 道德与法治命题工具包 - 一键安装脚本
# 使用方法：bash setup.sh

set -e

echo "========================================="
echo "  道德与法治命题工具包 安装脚本"
echo "========================================="
echo ""

SKILL_DIR="$HOME/.claude/skills"
MEMORY_DIR="$HOME/.claude/projects/-Users-liwvken/memory"

# 1. 安装技能
echo "[1/3] 安装技能到 $SKILL_DIR ..."
for skill in objective-question subjective-question scenario-judgment question-bank-manager; do
    if [ -d "$SKILL_DIR/$skill" ]; then
        echo "  ⚠ $skill 已存在，跳过"
    else
        cp -r "./skills/$skill" "$SKILL_DIR/"
        echo "  ✓ $skill 安装完成"
    fi
done

# 2. 安装记忆文件
echo "[2/3] 安装参考文件到 $MEMORY_DIR ..."
mkdir -p "$MEMORY_DIR/question-bank"
cp -n ./memory/proposition-general-requirements.md "$MEMORY_DIR/" 2>/dev/null || true
cp -n ./memory/textbook-*.md "$MEMORY_DIR/" 2>/dev/null || true
cp -n ./memory/textbook-xi-reader.md "$MEMORY_DIR/" 2>/dev/null || true

# 复制试题库目录结构（不覆盖已有文件）
cp -rn ./memory/question-bank/* "$MEMORY_DIR/question-bank/" 2>/dev/null || true
echo "  ✓ 参考文件安装完成"

# 3. 重启 Claude Code
echo "[3/3] 安装完成！"
echo ""
echo "请重启 Claude Code 或运行 /reload-plugins 使技能生效。"
echo "如果技能未自动加载，运行: claude plugin enable <skill-name>@skills-dir"
echo ""
echo "命题时请确保当前项目目录为 ~/.claude/"
