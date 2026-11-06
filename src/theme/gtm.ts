// Optional analytics. Set PUBLIC_GTM_ID at build time to enable; docs work without it.
export const googleTagManagerId: string | undefined = import.meta.env.PUBLIC_GTM_ID || undefined;

export const googleTagManagerScript = googleTagManagerId
  ? `(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','${googleTagManagerId}');`
  : undefined;
