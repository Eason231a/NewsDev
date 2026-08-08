<template>
  <div class="login-page">
    <div class="login-left">
      <div class="login-left__text">
        <p class="login-left__welcome">欢迎使用</p>
        <p class="login-left__system-name">黑马头条自媒体人管理系统</p>
      </div>
      <div class="login-left__illustration">
        <img src="@/assets/login-illustration.png" alt="illustration" />
      </div>
      <div class="login-left__dots">
        <span class="login-left__dot"></span>
        <span class="login-left__dot login-left__dot--long"></span>
      </div>
    </div>
    <div class="login-right">
      <div class="login-right__logo">
        <span class="login-right__logo-icon">H</span>
        <span class="login-right__logo-text">黑马头条</span>
      </div>
      <div class="login-form">
        <div class="login-form__group">
          <label class="login-form__label">用户名</label>
          <input
            v-model="form.username"
            type="text"
            class="login-form__input"
            placeholder="请输入"
          />
        </div>
        <div class="login-form__group">
          <label class="login-form__label">密码</label>
          <input
            v-model="form.password"
            type="password"
            class="login-form__input"
            placeholder="请输入"
          />
        </div>
        <div class="login-form__agreement">
          <label class="login-form__checkbox-label">
            <input
              v-model="form.agreeTerms"
              type="checkbox"
              class="login-form__checkbox"
            />
            <span class="login-form__checkbox-custom"></span>
            <span>我已阅读并同意用户协议和隐私政策条款</span>
          </label>
        </div>
        <button
          class="login-form__btn"
          :disabled="!form.agreeTerms || loading"
          @click="handleLogin"
        >
          {{ loading ? '登录中...' : '登 录' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const userStore = useUserStore()
const loading = ref(false)

const form = reactive({
  username: '',
  password: '',
  agreeTerms: false,
})

async function handleLogin() {
  if (!form.username || !form.password) {
    ElMessage.warning('请输入用户名和密码')
    return
  }
  loading.value = true
  try {
    await userStore.login({
      username: form.username,
      password: form.password,
      agreeTerms: form.agreeTerms,
    })
    ElMessage.success('登录成功')
    router.push('/dashboard')
  } catch {
    // Error handled by interceptor
  } finally {
    loading.value = false
  }
}
</script>

<style lang="scss" scoped>
.login-page {
  display: flex;
  height: 100vh;
  overflow: hidden;
}

// ========== Left: Brand area ==========
.login-left {
  flex: 1;
  background: #3a77fa;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: 48px;

  &__welcome {
    font-size: 30px;
    font-weight: 500;
    line-height: 36px;
    color: #fff;
    margin: 0 0 8px;
  }

  &__system-name {
    font-size: 24px;
    font-weight: 500;
    line-height: 32px;
    color: #fff;
    margin: 0;
  }

  &__illustration {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    max-width: 480px;
    max-height: 358px;
    margin: 0 auto;

    img {
      width: 100%;
      height: 100%;
      object-fit: contain;
    }
  }

  &__dots {
    display: flex;
    gap: 8px;
    opacity: 0.4;
  }

  &__dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #fff;

    &--long {
      width: 32px;
      border-radius: 22369600px;
    }
  }
}

// ========== Right: Form area ==========
.login-right {
  flex: 1;
  background: #fff;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 160px 48px;

  &__logo {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 48px;
  }

  &__logo-icon {
    width: 40px;
    height: 40px;
    background: #3a77fa;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    font-size: 20px;
    font-weight: 600;
  }

  &__logo-text {
    font-size: 20px;
    font-weight: 400;
    color: #1e2939;
  }
}

// ========== Form ==========
.login-form {
  width: 100%;
  max-width: 480px;

  &__group {
    margin-bottom: 24px;
  }

  &__label {
    font-size: 14px;
    font-weight: 500;
    color: #6a7282;
    margin-bottom: 8px;
    display: block;
  }

  &__input {
    width: 100%;
    padding: 4px 16px;
    height: 48px;
    background: #f9fafb;
    border: none;
    border-radius: 10px;
    font-size: 14px;
    color: #1e2939;
    outline: none;

    &::placeholder {
      color: #9ca3af;
    }

    &:focus {
      background: #f3f4f6;
    }
  }

  &__agreement {
    margin-bottom: 24px;
  }

  &__checkbox-label {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
    font-weight: 500;
    color: #6a7282;
    cursor: pointer;
  }

  &__checkbox {
    display: none;
  }

  &__checkbox-custom {
    width: 16px;
    height: 16px;
    border-radius: 4px;
    background: #f3f3f5;
    border: 0.67px solid rgba(0, 0, 0, 0.1);
    box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
    flex-shrink: 0;
    display: flex;
    align-items: center;
    justify-content: center;

    input:checked + & {
      background: #3a77fa;
      border-color: #3a77fa;
    }

    input:checked + &::after {
      content: '';
      width: 5px;
      height: 9px;
      border: solid #fff;
      border-width: 0 1.5px 1.5px 0;
      transform: rotate(45deg);
      margin-top: -1px;
    }
  }

  &__btn {
    width: 100%;
    padding: 12px;
    height: 48px;
    background: #3a77fa;
    color: #fff;
    border: none;
    border-radius: 10px;
    font-size: 16px;
    font-weight: 500;
    cursor: pointer;

    &:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    &:not(:disabled):hover {
      background: #2b6ae8;
    }
  }
}
</style>
