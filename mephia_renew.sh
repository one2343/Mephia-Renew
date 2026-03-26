#!/bin/bash

# 检查依赖
if ! command -v jq &> /dev/null; then
    echo "⚙️ 正在安装 jq..."
    sudo apt-get update && sudo apt-get install -y jq
fi

# 基础配置
GUILD_ID="1280090779766886437"
CHANNEL_ID="1312458506976235621"
COMMAND_ID="1482292602907922555"
APPLICATION_ID="1475048292449648650"
VERSION="1482292603159449629"

# 代理设置
PROXY=""
if [ -n "$GOST_PROXY" ]; then
    PROXY="-x http://127.0.0.1:8080"
    echo "🛡️ 代理模式已开启"
fi

# 解析账号数量
COUNT=$(echo "$ACCOUNTS_JSON" | jq '. | length')
echo "👥 检测到 $COUNT 个账号待处理"
echo "----------------------------------------"

for ((i=0; i<$COUNT; i++)); do
    # 提取当前账号信息
    ACC_NAME=$(echo "$ACCOUNTS_JSON" | jq -r ".[$i].name // \"账号$(($i+1))\"")
    ACC_TOKEN=$(echo "$ACCOUNTS_JSON" | jq -r ".[$i].token")
    ACC_SESSION=$(echo "$ACCOUNTS_JSON" | jq -r ".[$i].session")
    ACC_TG=$(echo "$ACCOUNTS_JSON" | jq -r ".[$i].tg_bot // \"$GLOBAL_TG_BOT\"")

    echo "▶️ 正在处理 [$ACC_NAME]..."

    # 生成 Discord Nonce
    NONCE=$(python3 -c "import time; print(str(int((int(time.time()*1000) - 1420070400000) << 22)))")

    # 构造 Payload
    PAYLOAD=$(jq -n \
        --arg app_id "$APPLICATION_ID" \
        --arg g_id "$GUILD_ID" \
        --arg c_id "$CHANNEL_ID" \
        --arg s_id "$ACC_SESSION" \
        --arg nonce "$NONCE" \
        --arg ver "$VERSION" \
        --arg cmd_id "$COMMAND_ID" \
        '{
            type: 2, application_id: $app_id, guild_id: $g_id, channel_id: $c_id, 
            session_id: $s_id, nonce: $nonce, analytics_location: "slash_ui",
            data: {
                version: $ver, id: $cmd_id, guild_id: $g_id, name: "renew", type: 1,
                options: [],
                application_command: {
                    id: $cmd_id, type: 1, application_id: $app_id, guild_id: $g_id, 
                    version: $ver, name: "renew", description: "Renouveler votre serveur gratuit"
                }
            }
        }')

    # 发送请求
    RESPONSE=$(curl -s -w "\n%{http_code}" $PROXY \
        -X POST "https://discord.com/api/v9/interactions" \
        -H "authorization: ${ACC_TOKEN}" \
        -H "content-type: application/json" \
        -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
        -d "$PAYLOAD")

    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)

    # 结果判定
    if [ "$HTTP_CODE" = "204" ] || [ "$HTTP_CODE" = "200" ]; then
        RESULT="✅ 续期成功"
        DETAIL="指令已成功送达 Discord"
    else
        RESULT="❌ 续期失败"
        # 提取 Discord 返回的具体错误原因，如果没有则显示状态码
        ERROR_MSG=$(echo "$BODY" | jq -r '.message // empty')
        [ -z "$ERROR_MSG" ] && DETAIL="HTTP 状态码: $HTTP_CODE" || DETAIL="原因: $ERROR_MSG"
    fi

    echo "  结果: $RESULT ($DETAIL)"

    # 发送 TG 通知
    if [ -n "$ACC_TG" ] && [ "$ACC_TG" != "null" ]; then
        TG_CHAT_ID=$(echo "$ACC_TG" | cut -d',' -f1)
        TG_TOKEN=$(echo "$ACC_TG" | cut -d',' -f2)
        
        MSG="🔔 *Mephia 续期通知*
👤 账号: ${ACC_NAME}
📊 结果: ${RESULT}
📝 详情: ${DETAIL}
⏰ 时间: $(date '+%Y-%m-%d %H:%M:%S')"

        curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
            -d chat_id="${TG_CHAT_ID}" \
            -d text="${MSG}" \
            -d parse_mode="Markdown" > /dev/null
    fi
    
    echo "----------------------------------------"
    sleep $((RANDOM % 6 + 5)) # 随机暂停 5 到 10 秒
done

echo "🏁 所有任务执行完毕"
