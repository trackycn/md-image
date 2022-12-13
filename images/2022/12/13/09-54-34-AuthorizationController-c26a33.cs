using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using NL.Framework.AspNetCore.Http;
using NL.Framework.AspNetCore.Mvc.Controllers;
using NL.Framework.Constants;
using NL.Framework.Extensions;
using Swashbuckle.AspNetCore.Annotations;

namespace ZhongShanMen.Service.Http.Controllers
{
    /// <summary>
    /// 授权控制器
    /// </summary>
    public class AuthorizationController : NalongAuthorizeControllerBase
    {
        private readonly IConfiguration _configuration;


        public AuthorizationController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        /// <summary>
        /// 获取密码加密 RSA 公钥
        /// </summary>
        /// <remarks>RSA 公钥 (PEM 格式, Padding: PKCS1)</remarks>
        /// <returns>RSA 公钥</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("/master-data/v5/account/rsa-public-key")]
        [SwaggerResponse(200, type: typeof(GenericResponse<string>))]
        public string GetRsaPublicKey()
        {
            return _configuration.GetStringValue(SystemConfigurationConstant.KEY_OF_OPEN_SSL_PUBLISH_KEY);
        }
    }
}
