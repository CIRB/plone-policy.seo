from Products.CMFCore.utils import getToolByName
from Products.LinguaPlone.browser.setup import SetupView


def setupLinguaFolders(site, logger):
    sw = SetupView(site, site.REQUEST)

    sw.folders = {}
    pl = getToolByName(site, "portal_languages")
    sw.languages = pl.getSupportedLanguages()
    if len(sw.languages) == 1:
        logger.error('Only one supported language configured.')
    sw.defaultLanguage = pl.getDefaultLanguage()
    available = pl.getAvailableLanguages()
    for language in sw.languages:
        info = available[language]
        sw.setUpLanguage(language, info.get('native', info.get('name')))

    sw.linkTranslations()
    sw.removePortalDefaultPage()
    # if sw.previousDefaultPageId:
    #     sw.resetDefaultPage()
    sw.setupLanguageSwitcher()


def setupVarious(context):

    # Ordinarily, GenericSetup handlers check for the existence of XML files.
    # Here, we are not parsing an XML file, but we use this text file as a
    # flag to check that we actually meant for this import step to be run.
    # The file is found in profiles/default.
    logger = context.getLogger('policy.seo')

    if context.readDataFile('policy.seo_various.txt') is None:
        return

    site = context.getSite()

    for folder_name in ['news', 'events', 'Members']:
        if getattr(site, folder_name, None):
            folder = getattr(site, folder_name)
            folder.setExcludeFromNav(True)
            folder.reindexObject()

    if not getattr(site, 'fr', None):
        setupLinguaFolders(site, logger)
        setup_tool = context.getSetupTool()
