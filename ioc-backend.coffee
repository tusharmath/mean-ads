ioc = require 'node-ioc'
{connections, providers, factories, modules, controllers} = bk = require './backend'

# Express
ioc.annotate(bk.express)
.inject(modules.RouteResolver, factories.ModelFactory)
.asSingleton()

# Connections
ioc.annotate(connections.RedisConnection)
.inject(providers.RedisProvider)

ioc.annotate(connections.DbConnection)
.inject(providers.MongooseProvider)


# Modules
ioc.annotate(modules.RouteResolver)
.inject(factories.ControllerFactory)

# Factories
ioc.annotate(factories.ControllerFactory)
.inject(ioc)
.resolveAs (mod)-> mod.Controllers
.asSingleton()

ioc.annotate(factories.ModelFactory)
.inject(connections.DbConnection, providers.MongooseProvider, providers.RequireProvider)
.resolveAs (mod) -> mod.create()
.asSingleton()

ioc.annotate(factories.DispatchFactory)
.inject(factories.ModelFactory,
    providers.DotProvider,
    providers.HtmlMinifierProvider,
    providers.DateProvider,
    modules.SubscriptionPopulator
    )

# Controllers
ioc.annotate(controllers.BaseController)
.inject(factories.ModelFactory)

ioc.annotate(controllers.CampaignController)
.inject(controllers.BaseController, modules.Dispatcher)

ioc.annotate(controllers.ProgramController)
.inject(controllers.BaseController, modules.Dispatcher)

ioc.annotate(controllers.StyleController)
.inject(controllers.BaseController, modules.Dispatcher)

ioc.annotate(controllers.SubscriptionController)
.inject(modules.Dispatcher, controllers.BaseController, modules.Mailer)

ioc.annotate(controllers.DispatchController)
.inject(modules.Dispatcher)


# Application Bootstrap
injector = new ioc()
app = injector.get bk.express
