'use strict';

const { utils } = require('surgio');

/**
 * 使用文档：https://surgio.js.org/
 *
 * 面板与接口鉴权通过环境变量注入：
 *   SURGIO_URL_BASE      对外访问地址，默认 http://localhost:3000/
 *   SURGIO_WEB_TOKEN     面板登录密码，缺省时自动生成，见容器日志
 *   SURGIO_VIEWER_TOKEN  订阅接口鉴权码，缺省时自动生成，见容器日志
 */
module.exports = {
  /**
   * 远程片段
   * 文档：https://surgio.js.org/guide/custom-config.html#remotesnippets
   */
  remoteSnippets: [
    {
      name: 'apple', // 模板中对应 remoteSnippets.apple
      url: 'https://github.com/geekdada/surge-list/raw/master/surgio-snippet/apple.tpl',
      surgioSnippet: true
    },
    {
      name: 'telegram', // 模板中对应 remoteSnippets.telegram
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Telegram/Telegram.list'
    },
    {
      name: 'netflix', // 模板中对应 remoteSnippets.netflix
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Netflix/Netflix.list'
    },
    {
      name: 'hbo', // 模板中对应 remoteSnippets.hbo
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/HBO/HBO.list'
    },
    {
      name: 'disney', // 模板中对应 remoteSnippets.disney
      url: 'https://github.com/geekdada/surge-list/raw/master/disney.list',
    },
    {
      name: 'overseaTlds', // 模板中对应 remoteSnippets.overseaTlds
      url: 'https://github.com/geekdada/surge-list/raw/master/oversea-tld.list',
    },
  ],
  customFilters: {
    hktFilter: utils.useKeywords(['hkt', 'HKT']),
  },
  artifacts: [
    /**
     * Surge
     */
    {
      name: 'SurgeV3.conf', // 新版 Surge
      template: 'surge_v3',
      provider: 'demo',
    },
    // 合并 Provider
    {
      name: 'SurgeV3_combine.conf',
      template: 'surge_v3',
      provider: 'demo',
      combineProviders: ['subscribe_demo'],
    },

    /**
     * Clash
     */
    {
      name: 'Clash.yaml',
      template: 'clash',
      provider: 'subscribe_demo',
    },
    {
      name: 'Clash_custom_dns.yaml',
      template: 'clash',
      provider: 'subscribe_demo',
      customParams: {
        dns: true,
      }
    },

    /**
     * Quantumult X
     */
    {
      name: 'QuantumultX_rules.conf',
      template: 'quantumultx_rules',
      provider: 'demo',
    },
    {
      name: 'QuantumultX.conf',
      template: 'quantumultx',
      provider: 'demo',
    },
    {
      name: 'QuantumultX_subscribe_us.conf',
      template: 'quantumultx_subscribe',
      provider: 'demo',
      customParams: {
        magicVariable: utils.usFilter,
      },
    },
    {
      name: 'QuantumultX_subscribe_hk.conf',
      template: 'quantumultx_subscribe',
      provider: 'demo',
      customParams: {
        magicVariable: utils.hkFilter,
      },
    },
  ],
  urlBase: process.env.SURGIO_URL_BASE || 'http://localhost:3000/',
  gateway: {
    auth: true,
    // 面板登录密码
    accessToken: process.env.SURGIO_WEB_TOKEN,
    /**
     * 专门用于调用以下三个接口的鉴权码
     * /get-artifact
     * /export-providers
     * /render
     */
    viewerToken: process.env.SURGIO_VIEWER_TOKEN,
    useCacheOnError: false,
  },

  // 非常有限的报错信息收集
  analytics: false,
};
