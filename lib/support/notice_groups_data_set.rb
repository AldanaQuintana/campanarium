ActiveSupport::Dependencies.autoload_paths << "app/workers"
class NoticeGroupsDataSet

  GROUPS = {

    tucuman: [
      {
        url: "http://tn.com.ar/politica/manzur-mis-dirigentes-quemaron-urnas-y-me-averguenza_614361",
        fetcher: TNFetcher
      },
      {
        url: "http://www.diarioveloz.com/notas/148862-tras-el-escandalo-tucuman-denuncian-al-matrimonio-alperovich-y-la-mediatica-marianela-mirra",
        fetcher: DiarioVelozFetcher
      },
      {
        url: "http://www.infobae.com/2015/08/27/1751293-jose-cano-el-gobierno-es-fraudulento-no-le-interesa-contar-voto-voto",
        fetcher: InfobaeFetcher
      }
    ],

    nisman: [
      {
        url: "http://www.diarioveloz.com/notas/148861-cambio-rumbo-quien-es-ruben-benitez-el-nuevo-apuntado-el-asesinato-alberto-nisman",
        fetcher: DiarioVelozFetcher
      },
      {
        url: "http://tn.com.ar/politica/la-ex-de-nisman-quiere-informe-de-embajada-de-cuba-y-que-declaren-medicos-enfermeras-y-periodista_614525",
        fetcher: TNFetcher
      },
      {
        url: "http://www.infobae.com/2015/08/27/1751270-caso-nisman-la-querella-apunta-un-custodio-que-se-desempeno-la-embajada-cuba",
        fetcher: InfobaeFetcher
      }
    ],

    cars: [
      {
        url: "http://tn.com.ar/autos/lo-ultimo/tn-autos-mira-el-anticipo-del-proximo-programa_613104\n",
        fetcher: TNFetcher
      },
      {
        url: "http://tn.com.ar/autos/lo-ultimo/conoce-la-impresionante-mercedes-gle-de-650-caballos_613101",
        fetcher: TNFetcher
      }
    ],

    nisman_lavado: [
      {
        url: "http://www.infobae.com/2015/08/27/1751153-pidieron-la-indagatoria-la-mama-y-la-hermana-nisman-lavado-dinero",
        fetcher: InfobaeFetcher
      }
    ]
  }


  def self.create_groups
    puts "=========================== starting creation ==========================="
    GROUPS.each do |group_name, notices|
      NoticeGroup.create(notices:
        notices.map{|notice| notice[:fetcher].new.fetch_notice notice[:url] })
    end
    puts "=========================== finished creation ==========================="
  end
end