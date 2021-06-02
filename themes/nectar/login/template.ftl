<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false showAnotherWayIfPresent=true>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" class="${properties.kcHtmlClass!}">

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">

    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
    <#if properties.stylesCommon?has_content>
        <#list properties.stylesCommon?split(' ') as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>
</head>

<body class="${properties.kcBodyClass!}">
<div class="${properties.kcLoginClass!}">
    <div id="kc-header" class="${properties.kcHeaderClass!}">
        <div id="kc-header-wrapper"
             class="${properties.kcHeaderWrapperClass!}">${kcSanitize(msg("loginTitleHtml",(realm.displayNameHtml!'')))?no_esc}</div>
    </div>
    <div class="${properties.kcFormCardClass!}">
        <header class="${properties.kcFormHeaderClass!}">
            <#if realm.internationalizationEnabled  && locale.supported?size gt 1>
                <div class="${properties.kcLocaleMainClass!}" id="kc-locale">
                    <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                        <div id="kc-locale-dropdown" class="${properties.kcLocaleDropDownClass!}">
                            <a href="#" id="kc-current-locale-link">${locale.current}</a>
                            <ul class="${properties.kcLocaleListClass!}">
                                <#list locale.supported as l>
                                    <li class="${properties.kcLocaleListItemClass!}">
                                        <a class="${properties.kcLocaleItemClass!}" href="${l.url}">${l.label}</a>
                                    </li>
                                </#list>
                            </ul>
                        </div>
                    </div>
                </div>
            </#if>
        <#if !(auth?has_content && auth.showUsername() && !auth.showResetCredentials())>
            <#if displayRequiredFields>
                <div class="${properties.kcContentWrapperClass!}">
                    <div class="${properties.kcLabelWrapperClass!} subtitle">
                        <span class="subtitle"><span class="required">*</span> ${msg("requiredFields")}</span>
                    </div>
                    <div class="col-md-10">
                        <h1 id="kc-page-title"><#nested "header"></h1>
                    </div>
                </div>
            <#else>
                <h1 id="kc-page-title"><#nested "header"></h1>
            </#if>
        <#else>
            <#if displayRequiredFields>
                <div class="${properties.kcContentWrapperClass!}">
                    <div class="${properties.kcLabelWrapperClass!} subtitle">
                        <span class="subtitle"><span class="required">*</span> ${msg("requiredFields")}</span>
                    </div>
                    <div class="col-md-10">
                        <#nested "show-username">
                        <div id="kc-username" class="${properties.kcFormGroupClass!}">
                            <label id="kc-attempted-username">${auth.attemptedUsername}</label>
                            <a id="reset-login" href="${url.loginRestartFlowUrl}">
                                <div class="kc-login-tooltip">
                                    <i class="${properties.kcResetFlowIcon!}"></i>
                                    <span class="kc-tooltip-text">${msg("restartLoginTooltip")}</span>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            <#else>
                <#nested "show-username">
                <div id="kc-username" class="${properties.kcFormGroupClass!}">
                    <label id="kc-attempted-username">${auth.attemptedUsername}</label>
                    <a id="reset-login" href="${url.loginRestartFlowUrl}">
                        <div class="kc-login-tooltip">
                            <i class="${properties.kcResetFlowIcon!}"></i>
                            <span class="kc-tooltip-text">${msg("restartLoginTooltip")}</span>
                        </div>
                    </a>
                </div>
            </#if>
        </#if>
      </header>
      <div id="kc-content">
        <div id="kc-content-wrapper">

          <#-- App-initiated actions should not see warning messages about the need to complete the action -->
          <#-- during login.                                                                               -->
          <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
              <div class="alert-${message.type} ${properties.kcAlertClass!} pf-m-<#if message.type = 'error'>danger<#else>${message.type}</#if>">
                  <div class="pf-c-alert__icon">
                      <#if message.type = 'success'><span class="${properties.kcFeedbackSuccessIcon!}"></span></#if>
                      <#if message.type = 'warning'><span class="${properties.kcFeedbackWarningIcon!}"></span></#if>
                      <#if message.type = 'error'><span class="${properties.kcFeedbackErrorIcon!}"></span></#if>
                      <#if message.type = 'info'><span class="${properties.kcFeedbackInfoIcon!}"></span></#if>
                  </div>
                      <span class="${properties.kcAlertTitleClass!}">${kcSanitize(message.summary)?no_esc}</span>
              </div>
          </#if>

          <#nested "form">

            <#if auth?has_content && auth.showTryAnotherWayLink() && showAnotherWayIfPresent>
                <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post">
                    <div class="${properties.kcFormGroupClass!}">
                        <input type="hidden" name="tryAnotherWay" value="on"/>
                        <a href="#" id="try-another-way"
                           onclick="document.forms['kc-select-try-another-way-form'].submit();return false;">${msg("doTryAnotherWay")}</a>
                    </div>
                </form>
            </#if>

          <#if displayInfo>
              <div id="kc-info" class="${properties.kcSignUpClass!}">
                  <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}">
                      <#nested "info">
                  </div>
              </div>
          </#if>
        </div>
      </div>

    </div>

  </div>

  <footer class="footer">
    <div class="nectar-container">

      <div class="row h-100">
        <div class="col-xs-8 footer-text">
          <small>The Nectar Research Cloud is a service of the Australian Research Data Commons (ARDC).
             The Australian Research Data Commons (ARDC) is enabled by the National Collaborative Research Infrastructure Strategy Program (NCRIS).
             <a href="https://ardc.edu.au/about/" target="_blank">Read more about the ARDC...</a>
          </small>
        </div>

        <div class="col-xs-4">
          <div class="row vertical-align">
            <div class="col-md-7">
                <a href="https://www.ardc.edu.au/" target="_blank">
                  <img src="${url.resourcesPath}/img/ardc_logo_rev.svg" style="zwidth: 200px;" class="img-responsive" alt="Australian Research Data Commons (ARDC)"/>
                </a>
            </div>
            <div class="col-md-5">
                <a href="https://education.gov.au/national-collaborative-research-infrastructure-strategy-ncris" target="_blank">
                  <img src="${url.resourcesPath}/img/ncris_mono_rev.svg" style="zwidth: 100px;" class="img-responsive" alt="National Collaborative Research Infrastructure Strategy (NCRIS)" />
                </a>
            </div>
          </div>
        </div>
      </div> <!-- row -->
    
      <div class="row h-100 footer-links">
        <div class="col-sm-3 col-xs-6">
          <h3>Quicklinks</h3>
          <ul>
            <li><a href="/">Home</a></li>
            <li><a href="/terms">Terms and Conditions</a></li>
          </ul>
        </div>

        <div class="col-sm-3 col-xs-6">
          <h3>Explore</h3>
          <ul>
            <li><a href="https://support.ehelp.edu.au/support/solutions/folders/6000190150">Cloud Basics</a></li>
            <li><a href="https://support.ehelp.edu.au/support/solutions/folders/6000232361">Cloud Services</a></li>
            <li><a href="https://support.ehelp.edu.au/support/solutions/folders/6000230414">Cloud Applications</a></li>
            <li><a href="https://support.ehelp.edu.au/support/solutions/folders/6000190155">Cloud Fundamentals</a></li>
          </ul>
        </div>

        <div class="col-sm-3 col-xs-6">
          <h3>Help</h3>
          <ul>
            <li><a href="https://support.ehelp.edu.au/support/tickets/new" target="_blank">Request Support</a></li>
            <li><a href="https://tutorials.rc.nectar.org.au">Tutorials</a></li>
          </ul>
        </div>

        <div class="col-sm-3 col-xs-6">
          <h3>External Resources</h3>
          <ul>
            <li><a href="https://ardc.edu.au/">ARDC Home</a></li>
            <li><a href="https://dashboard.rc.nectar.org.au/">Nectar Dashboard</a></li>
            <li><a href="https://ardc.edu.au/services/">ARDC Online Services</a></li>
          </ul>
        </div>
      </div> <!-- row -->

    </div> <!-- nectar-container -->
  </footer>

</body>
</html>
</#macro>

