ActiveSupport::Dependencies.autoload_paths << "app/workers"
class NoticeGroupsDataSet

  GROUPS = {

    tucuman: {
      noticias: [
        {
          url: "http://tn.com.ar/politica/manzur-mis-dirigentes-quemaron-urnas-y-me-averguenza_614361",
          fetcher: TnFetcher
        },
        {
          url: "http://www.diarioveloz.com/notas/148862-tras-el-escandalo-tucuman-denuncian-al-matrimonio-alperovich-y-la-mediatica-marianela-mirra",
          fetcher: DiarioVelozFetcher
        },
        {
          url: "http://www.infobae.com/2015/08/27/1751293-jose-cano-el-gobierno-es-fraudulento-no-le-interesa-contar-voto-voto",
          fetcher: InfobaeFetcher
        },
        {
          url: "http://www.lanacion.com.ar/1821772-escandalo-de-violencia-y-quema-de-urnas-en-las-elecciones-en-tucuman",
          fetcher: LaNacionFetcher
        }
      ],
      comments_search_query: '#FraudeEnTucuman'
    },

    nisman: {
      noticias: [
        {
          url: "http://www.diarioveloz.com/notas/148861-cambio-rumbo-quien-es-ruben-benitez-el-nuevo-apuntado-el-asesinato-alberto-nisman",
          fetcher: DiarioVelozFetcher
        },
        {
          url: "http://tn.com.ar/politica/la-ex-de-nisman-quiere-informe-de-embajada-de-cuba-y-que-declaren-medicos-enfermeras-y-periodista_614525",
          fetcher: TnFetcher
        },
        {
          url: "http://www.infobae.com/2015/08/27/1751270-caso-nisman-la-querella-apunta-un-custodio-que-se-desempeno-la-embajada-cuba",
          fetcher: InfobaeFetcher
        },
        {
          url: "http://www.lanacion.com.ar/1762996-el-dia-antes-de-morir-nisman-tambien-le-pidio-un-arma-a-uno-de-sus-custodios",
          fetcher: LaNacionFetcher
        }
      ],
      comments_search_query: 'nisman ruben benitez'
    },

    detroit: {
      noticias: [
        {
          url: "http://www.lanacion.com.ar/1760932-con-el-brillo-y-las-sonrisas-de-los-mejores-anos",
          fetcher: LaNacionFetcher
        },
        {
          url: "http://www.infobae.com/2015/01/13/1620585-lo-mejor-del-salon-del-automovil-detroit-2015",
          fetcher: InfobaeFetcher
        },
        {
          url: "http://tn.com.ar/internacional/el-salon-del-automovil-de-detroit-se-pone-verde_439555",
          fetcher: TnFetcher
        }
      ],
      comments_search_query: 'salon automovil detroit'
    },

    nisman_lavado: {
      noticias: [
        {
          url: "http://www.infobae.com/2015/08/27/1751153-pidieron-la-indagatoria-la-mama-y-la-hermana-nisman-lavado-dinero",
          fetcher: InfobaeFetcher
        }
      ],
      comments_search_query: 'nisman lavado dinero'
    }
  }


  def self.create_groups
    comments_fetcher = CommentsFetcher.new
    puts "=========================== starting creation ==========================="
    GROUPS.each do |group_name, data|
      notices = data[:noticias]
      comments_search_query = data[:comments_search_query]
      NoticeGroup.create(
        notices: notices.map{|notice| notice[:fetcher].new.fetch_notice notice[:url] },
        comments: comments_fetcher.search_and_persist(comments_search_query)
      )
    end
    puts "=========================== finished creation ==========================="
  end
end