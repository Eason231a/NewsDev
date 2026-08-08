import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { UserInfo } from '@/types/user'
import { getToken, setToken, removeToken } from '@/utils/auth'
import { login as loginApi, getUserInfo as getUserInfoApi } from '@/api/auth'
import type { LoginRequest } from '@/types/user'

export const useUserStore = defineStore('user', () => {
  const token = ref<string | null>(getToken())
  const userInfo = ref<UserInfo | null>(null)

  const isLoggedIn = computed(() => !!token.value)

  async function login(loginData: LoginRequest) {
    const res = await loginApi(loginData)
    setToken(res.data.token)
    token.value = res.data.token
    userInfo.value = res.data.user
  }

  async function fetchUser() {
    if (!token.value) return
    const res = await getUserInfoApi()
    userInfo.value = res.data
  }

  function logout() {
    removeToken()
    token.value = null
    userInfo.value = null
  }

  return {
    token,
    userInfo,
    isLoggedIn,
    login,
    fetchUser,
    logout,
  }
})
