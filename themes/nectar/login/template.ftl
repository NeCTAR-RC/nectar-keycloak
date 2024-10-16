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
        <div id="kc-header-wrapper" class="${properties.kcHeaderWrapperClass!}">
            <img src="${url.resourcesPath}/img/ardc-logo.svg" alt="Australian Research Data Commons" width="320" height="105" />
            ${kcSanitize(msg("loginTitleHtml",(realm.displayNameHtml!'')))?no_esc}
        </div>
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


    <!-- ARDC footer -->
    <footer id="ardc-footer" role="contentinfo">
        <div class="footer-row">
            <div class="nectar-container">
                <div class="row">
                    <div class="mb-2 col-12 col-md-6 col-lg-4 footer-logos">
                        <a href="https://www.education.gov.au/ncris">
                            <img id="ncris-logo" src="https://object-store.rc.nectar.org.au/v1/AUTH_2f6f7e75fc0f453d9c127b490b02e9e3/web_images/ncris-provider.svg" width="176" height="127" alt="National Collaborative Research Infrastructure Strategy">
                        </a>
                        <p class="footer-image-description">The Australian Research Data Commons is enabled by NCRIS.</p>
                    </div>
                    <div class="mb-2 col-12 col-md-6 col-lg-4">
                        <!-- ARDC newsletter sign up form -->
                        <div id="mc_embed_shell">
                            <div id="mc_embed_signup">
                            <form action="https://ardc.us7.list-manage.com/subscribe/post?u=b542ef52e49302569068046d9&amp;id=22b849a4ee&amp;f_id=00e7c2e1f0" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_self" novalidate="">
                            <div id="mc_embed_signup_scroll">
                                <h2>ARDC NEWSLETTER SIGNUP</h2>
                                <div class="ardc-custom--fields-grid-wrapper">
                                <div class="mc-field-group">
                                    <label for="mce-FNAME" class="screen-reader-text">First Name </label>
                                    <input type="text" name="FNAME" class="fname" id="mce-FNAME" value="" placeholder="First Name">
                                    <div id="fname-error" class="error-message">This field is required.</div>
                                </div>
                                <div class="mc-field-group">
                                    <label for="mce-LNAME" class="screen-reader-text">Last Name </label>
                                    <input type="text" name="LNAME" class="lname" id="mce-LNAME" value="" placeholder="Last Name">
                                    <div id="lname-error" class="error-message">This field is required.</div>
                                </div>
                                <div class="mc-field-group">
                                    <label for="mce-EMAIL" class="screen-reader-text">Email Address <span class="asterisk">*</span>
                                    </label>
                                    <input type="email" name="EMAIL" class="required email" id="mce-EMAIL" required="" value="" placeholder="Email">
                                    <div id="email-error" class="error-message">This field is required.</div>
                                </div>
                                <div class="mc-field-group">
                                    <label for="mce-group[20]" class="screen-reader-text">I am</label>
                                    <select name="group[20]" id="mce-group[20]">
                                    <option value="512">A Researcher</option>
                                    <option value="1024">A Research Support Professional - OR Research Data / Software and Infrastructure Professional</option>
                                    <option value="2048">Librarian / Trainer</option>
                                    <option value="4096">A Manager of People and/or Policy</option>
                                    </select>
                                </div>
                                </div>

                                <div>
                                <input type="hidden" name="tags" value="791380">
                                </div>
                                <div class="screen-reader-text" aria-hidden="true" style="position: absolute;left: -5000px;">
                                <input type="text" name="b_b542ef52e49302569068046d9_22b849a4ee" tabindex="-1" value="">
                                </div>
                                <div class="clear">
                                <button id="signup-modal-trigger" data-target="#mc-signup-modal" type="button" class="button">Subscribe</button>
                                </div>
                            </div>

                            <div id="mc-signup-modal">
                                <div class="mc-field-group input-group">
                                <p>
                                    <strong>Confirm what you are interested in:</strong>
                                    <span style="color: #c02b0a;font-size: 13px;"><em>(Required)</em></span>
                                    <button type="button" class="close-modal js-close-modal">x</button>
                                </p>
                                <ul>
                                    <li>
                                    <input type="checkbox" name="group[24][1]" id="mce-group[24]-24-0" value="">
                                    <label for="mce-group[24]-24-0">All</label>
                                    </li>
                                    <li>
                                    <input type="checkbox" name="group[24][65536]" id="mce-group[24]-24-1" value="">
                                    <label for="mce-group[24]-24-1">Biological and Biotechnological Sciences</label>
                                    </li>
                                    <li>
                                    <input type="checkbox" name="group[24][16]" id="mce-group[24]-24-2" value="">
                                    <label for="mce-group[24]-24-2">Engineering</label>
                                    </li>
                                    <li>
                                    <input type="checkbox" name="group[24][8192]" id="mce-group[24]-24-3" value="">
                                    <label for="mce-group[24]-24-3">Environmental and Agricultural Sciences</label>
                                    </li>
                                    <li>
                                    <input type="checkbox" name="group[24][16384]" id="mce-group[24]-24-4" value="">
                                    <label for="mce-group[24]-24-4">Humanities Arts and Social Sciences (HASS)</label>
                                    </li>
                                    <li>
                                    <input type="checkbox" name="group[24][262144]" id="mce-group[24]-24-5" value="">
                                    <label for="mce-group[24]-24-5">Indigenous Studies</label>
                                    </li>
                                    <li>
                                    <input type="checkbox" name="group[24][524288]" id="mce-group[24]-24-6" value="">
                                    <label for="mce-group[24]-24-6">Mathematical-Information and Computing Sciences</label>
                                    </li>
                                    <li>
                                    <input type="checkbox" name="group[24][32768]" id="mce-group[24]-24-7" value="">
                                    <label for="mce-group[24]-24-7">Medical and Health Sciences</label>
                                    </li>
                                    <li>
                                    <input type="checkbox" name="group[24][131072]" id="mce-group[24]-24-8" value="">
                                    <label for="mce-group[24]-24-8">Physical-Chemical and Earth Sciences</label>
                                    </li>
                                </ul>
                                <div class="error-message" aria-hidden="true">This field is required!</div>
                                <div>
                                    <input type="submit" name="subscribe" id="mc-embedded-subscribe" class="button" value="Confirm">
                                </div>
                                </div>
                            </div>

                            </form>
                            </div>

                            <script src="https://static.freshdev.io/fdk/2.0/assets/fresh_parent.js"></script><script>
                            const embedShell=document.getElementById("mc_embed_shell"),modalBtn=embedShell.querySelector("#signup-modal-trigger"),signupForm=embedShell.querySelector("#mc-embedded-subscribe-form"),fnameField=embedShell.querySelector(".fname"),lnameField=embedShell.querySelector(".lname"),emailField=embedShell.querySelector(".email");function anyCheckboxIsChecked(e){let l=!1;for(let t of e)if(t.checked){l=!0;break}return l}function closeModalHandler(e,l){e.addEventListener("click",e=>{l.classList.remove("active")})}function submitModalHandler(e,l,t,a){e.addEventListener("click",e=>{e.preventDefault(),anyCheckboxIsChecked(l)?t.submit():a.classList.add("error")})}modalBtn.addEventListener("click",e=>{let l=embedShell.querySelector(e.target.dataset.target),t=l.querySelector('input[type="submit"]'),a=""==fnameField.value||""==lnameField.value||""==emailField.value;if(l&&!a){let d=l.querySelectorAll('input[type="checkbox"]'),r=l.querySelector(".js-close-modal");closeModalHandler(r,l),l.classList.add("active"),submitModalHandler(t,d,signupForm,l)}else document.getElementById("fname-error").style.display=""==fnameField.value?"block":"none",document.getElementById("lname-error").style.display=""==lnameField.value?"block":"none",document.getElementById("email-error").style.display=""==emailField.value?"block":"none"});
                            </script>

                        </div>
                    </div>
                    <div class="mb-2 col-12 col-md-12 col-lg-4 footer-links">
                        <h4 class="footer-heading">Quick Links</h4>
                        <ul class="footer-list list-bullet">
                            <li><a href="https://ardc.edu.au/privacy-policy/" target="_blank" title="Privacy Policy">Privacy Policy</a></li>
                            <li><a href="https://support.ehelp.edu.au/" title="Nectar Support Home">ARDC Nectar Support</a></li>
                            <li><a href="https://ardc.edu.au/" target="_blank" title="ARDC Website">ARDC Website</a></li>
                            <li><a href="https://ardc.edu.au/contact-us/" target="_blank" title="Contact ARDC">Contact ARDC</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-row bg-light">
            <div class="nectar-container">
                <div class="row footer-acknowledgement">
                    <p>We acknowledge and celebrate the First Australians on whose traditional lands we live and work, and we pay our respects to Elders past, present and emerging.</p>
                </div>
            </div>
        </div>
        <div class="footer-row">
            <div class="nectar-container">
                <div class="footer-copyright d-flex flex-wrap align-items-center">
                    <span class="copyright">Copyright © <script type="text/javascript">document.write( new Date().getFullYear() );</script>2024 ARDC. <a href="https://www.acnc.gov.au/charity/charities/eca273f3-f5be-e911-a98a-000d3ad02a61/profile" target="_blank" rel="noopener noreferrer">ACN 633 798 857</a></span>
                    <a href="https://ardc.edu.au/terms-and-conditions/" target="_blank" class="footer-link" rel="noopener noreferrer"><span class="disclaimer">Terms and Conditions</span></a>
                    <a href="https://ardc.edu.au/privacy-policy/" target="_blank" class="footer-link" rel="noopener noreferrer"><span class="privacy">Privacy Policy</span></a>
                    <a href="https://ardc.edu.au/accessibility-statement-for-ardc/" target="_blank" class="footer-link" rel="noopener noreferrer"><span class="accessibility">Accessibility Statement</span></a>
                </div>
            </div>
        </div>
    </footer>
</body>
</html>
</#macro>

