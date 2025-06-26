#!/bin/bash

if ! command -v jq &> /dev/null
then
    
    echo "-> 'jq' chưa được cài đặt. Bắt đầu quá trình cài đặt tự động..."
    
    pkg update -y && pkg install -y jq
    
    if ! command -v jq &> /dev/null
    then
        
        echo "LỖI: Không thể cài đặt 'jq'. Vui lòng kiểm tra kết nối mạng và quyền của Termux."
        exit 1
    else
        echo "-> 'jq' đã được cài đặt thành công."
    fi
fi


CONFIG_FILE=~/ccminer/config.json


if [ ! -f "$CONFIG_FILE" ]; then
    echo "Lỗi: Không tìm thấy file config tại '$CONFIG_FILE'."
    echo "Vui lòng tạo file với nội dung JSON hợp lệ trước."
    exit 1
fi


echo "---------------------------------"
echo "Đang đọc cấu hình hiện tại từ $CONFIG_FILE..."
current_pool_address=$(jq -r '.pools[0].url' "$CONFIG_FILE")
current_user_string=$(jq -r '.user' "$CONFIG_FILE")

current_wallet_address=$(echo "$current_user_string" | cut -d'.' -f1)
current_device_name=$(echo "$current_user_string" | cut -d'.' -f2-)

echo "Cấu hình hiện tại:"
echo "  - Tên giàn (RIG NAME): $current_device_name"
echo "  - Địa chỉ POOL: $current_pool_address"
echo "  - Địa chỉ VÍ (WALLET): $current_wallet_address"
echo "---------------------------------"
echo "Nhập thông tin mới hoặc nhấn ENTER để giữ nguyên giá trị cũ."
echo ""


echo -n "Nhập RIG NAME mới: "
read new_device_name < /dev/tty

echo -n "Nhập POOL ADDRESS mới: "
read new_pool_address < /dev/tty

echo -n "Nhập WALLET ADDRESS mới: "
read new_wallet_address < /dev/tty


final_device_name=${new_device_name:-$current_device_name}
final_pool_address=${new_pool_address:-$current_pool_address}
final_wallet_address=${new_wallet_address:-$current_wallet_address}
final_user_string="${final_wallet_address}.${final_device_name}"

updated_json=$(jq \
  --arg pool "$final_pool_address" \
  --arg user "$final_user_string" \
  '.pools[0].url = $pool | .user = $user' \
  "$CONFIG_FILE")

if [ $? -eq 0 ]; then
  echo "$updated_json" > "$CONFIG_FILE"
  echo "---------------------------------"
  echo "✅ Cập nhật file config.json thành công."
  echo "Cấu hình mới:"
  echo "  - Tên giàn (RIG NAME): $final_device_name"
  echo "  - Địa chỉ POOL: $final_pool_address"
  echo "  - Địa chỉ VÍ (WALLET): $final_wallet_address"
  echo "  - Chuỗi user đầy đủ: $final_user_string"
else
  echo "❌ Đã có lỗi xảy ra trong quá trình cập nhật file config.json."
fi
