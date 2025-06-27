#!/usr/bin/env python3
"""
测试PPT字体替换API的完整工作流程
"""

import requests
import time
import os

API_BASE_URL = 'http://localhost:5001/api/ppt'
TEST_FILE_PATH = '/home/ubuntu/ppt-font-changer/test_presentation.pptx'

def test_complete_workflow():
    """测试完整的工作流程"""
    
    print("=== PPT字体替换API测试 ===")
    
    # 1. 检查测试文件是否存在
    if not os.path.exists(TEST_FILE_PATH):
        print(f"❌ 测试文件不存在: {TEST_FILE_PATH}")
        return False
    
    print(f"✅ 测试文件存在: {TEST_FILE_PATH}")
    file_size = os.path.getsize(TEST_FILE_PATH)
    print(f"   文件大小: {file_size / 1024:.2f} KB")
    
    # 2. 测试文件上传
    print("\n📤 测试文件上传...")
    try:
        with open(TEST_FILE_PATH, 'rb') as f:
            files = {'file': ('test_presentation.pptx', f, 'application/vnd.openxmlformats-officedocument.presentationml.presentation')}
            response = requests.post(f'{API_BASE_URL}/upload', files=files)
        
        if response.status_code == 200:
            upload_result = response.json()
            file_id = upload_result['file_id']
            print(f"✅ 文件上传成功")
            print(f"   文件ID: {file_id}")
            print(f"   文件名: {upload_result['filename']}")
            print(f"   文件大小: {upload_result['file_size']} bytes")
        else:
            print(f"❌ 文件上传失败: {response.status_code}")
            print(f"   错误信息: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ 文件上传异常: {str(e)}")
        return False
    
    # 3. 测试文件处理
    print("\n🔄 测试文件处理...")
    try:
        process_data = {
            'file_id': file_id,
            'chinese_font': 'Noto Sans SC',
            'english_font': 'NVIDIA Sans'
        }
        
        response = requests.post(f'{API_BASE_URL}/process', json=process_data)
        
        if response.status_code == 200:
            process_result = response.json()
            print(f"✅ 文件处理成功")
            print(f"   处理统计:")
            stats = process_result['processing_stats']
            print(f"     - 处理幻灯片: {stats['processed_slides']}/{stats['total_slides']}")
            print(f"     - 处理段落: {stats['processed_paragraphs']}/{stats['total_paragraphs']}")
            print(f"     - 中文字符: {stats['chinese_chars']} 个")
            print(f"     - 英文字符: {stats['english_chars']} 个")
            print(f"     - 其他字符: {stats['other_chars']} 个")
            if stats['errors']:
                print(f"     - 错误: {len(stats['errors'])} 个")
                for error in stats['errors'][:3]:  # 只显示前3个错误
                    print(f"       * {error}")
        else:
            print(f"❌ 文件处理失败: {response.status_code}")
            print(f"   错误信息: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ 文件处理异常: {str(e)}")
        return False
    
    # 4. 测试文件下载
    print("\n📥 测试文件下载...")
    try:
        response = requests.get(f'{API_BASE_URL}/download/{file_id}')
        
        if response.status_code == 200:
            output_path = '/home/ubuntu/ppt-font-changer/test_output.pptx'
            with open(output_path, 'wb') as f:
                f.write(response.content)
            
            output_size = os.path.getsize(output_path)
            print(f"✅ 文件下载成功")
            print(f"   输出文件: {output_path}")
            print(f"   输出大小: {output_size / 1024:.2f} KB")
            
            # 比较文件大小
            size_diff = output_size - file_size
            print(f"   大小变化: {size_diff:+d} bytes ({size_diff/file_size*100:+.1f}%)")
            
        else:
            print(f"❌ 文件下载失败: {response.status_code}")
            print(f"   错误信息: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ 文件下载异常: {str(e)}")
        return False
    
    # 5. 测试状态查询
    print("\n📊 测试状态查询...")
    try:
        response = requests.get(f'{API_BASE_URL}/status/{file_id}')
        
        if response.status_code == 200:
            status_result = response.json()
            print(f"✅ 状态查询成功")
            print(f"   状态: {status_result['status']}")
            print(f"   消息: {status_result['message']}")
        else:
            print(f"❌ 状态查询失败: {response.status_code}")
            print(f"   错误信息: {response.text}")
            
    except Exception as e:
        print(f"❌ 状态查询异常: {str(e)}")
    
    # 6. 测试文件清理
    print("\n🗑️  测试文件清理...")
    try:
        response = requests.delete(f'{API_BASE_URL}/cleanup/{file_id}')
        
        if response.status_code == 200:
            cleanup_result = response.json()
            print(f"✅ 文件清理成功")
            print(f"   删除文件数: {cleanup_result['deleted_files']}")
        else:
            print(f"❌ 文件清理失败: {response.status_code}")
            print(f"   错误信息: {response.text}")
            
    except Exception as e:
        print(f"❌ 文件清理异常: {str(e)}")
    
    print("\n🎉 API测试完成！")
    return True

if __name__ == "__main__":
    # 等待Flask服务启动
    print("等待Flask服务启动...")
    time.sleep(3)
    
    # 运行测试
    success = test_complete_workflow()
    
    if success:
        print("\n✅ 所有测试通过！")
    else:
        print("\n❌ 测试失败！")

