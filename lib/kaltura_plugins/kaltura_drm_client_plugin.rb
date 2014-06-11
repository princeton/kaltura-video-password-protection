# ===================================================================================================
#                           _  __     _ _
#                          | |/ /__ _| | |_ _  _ _ _ __ _
#                          | ' </ _` | |  _| || | '_/ _` |
#                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
#
# This file is part of the Kaltura Collaborative Media Suite which allows users
# to do with audio, video, and animation what Wiki platfroms allow them to do with
# text.
#
# Copyright (C) 2006-2011  Kaltura Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http:#www.gnu.org/licenses/>.
#
# @ignore
# ===================================================================================================
require 'kaltura_client.rb'

module Kaltura

	class KalturaDrmProfileStatus
		ACTIVE = 1
		DELETED = 2
	end

	class KalturaDrmProfileOrderBy
		ID_ASC = "+id"
		NAME_ASC = "+name"
		ID_DESC = "-id"
		NAME_DESC = "-name"
	end

	class KalturaDrmProviderType
		WIDEVINE = "widevine.WIDEVINE"
	end

	class KalturaDrmProfile < KalturaObjectBase
		attr_accessor :id
		attr_accessor :partner_id
		attr_accessor :name
		attr_accessor :description
		attr_accessor :provider
		attr_accessor :status
		attr_accessor :license_server_url
		attr_accessor :default_policy
		attr_accessor :created_at
		attr_accessor :updated_at

		def id=(val)
			@id = val.to_i
		end
		def partner_id=(val)
			@partner_id = val.to_i
		end
		def status=(val)
			@status = val.to_i
		end
		def created_at=(val)
			@created_at = val.to_i
		end
		def updated_at=(val)
			@updated_at = val.to_i
		end
	end

	class KalturaDrmProfileListResponse < KalturaObjectBase
		attr_accessor :objects
		attr_accessor :total_count

		def total_count=(val)
			@total_count = val.to_i
		end
	end

	class KalturaDrmProfileBaseFilter < KalturaFilter
		attr_accessor :id_equal
		attr_accessor :id_in
		attr_accessor :partner_id_equal
		attr_accessor :partner_id_in
		attr_accessor :name_like
		attr_accessor :provider_equal
		attr_accessor :provider_in
		attr_accessor :status_equal
		attr_accessor :status_in

		def id_equal=(val)
			@id_equal = val.to_i
		end
		def partner_id_equal=(val)
			@partner_id_equal = val.to_i
		end
		def status_equal=(val)
			@status_equal = val.to_i
		end
	end

	class KalturaDrmProfileFilter < KalturaDrmProfileBaseFilter

	end


	class KalturaDrmProfileService < KalturaServiceBase
		def initialize(client)
			super(client)
		end

		# Allows you to add a new DrmProfile object
		# 	 
		def add(drm_profile)
			kparams = {}
			client.add_param(kparams, 'drmProfile', drm_profile);
			client.queue_service_action_call('drm_drmprofile', 'add', kparams);
			if (client.is_multirequest)
				return nil;
			end
			return client.do_queue();
		end

		# Retrieve a KalturaDrmProfile object by ID
		# 	 
		def get(drm_profile_id)
			kparams = {}
			client.add_param(kparams, 'drmProfileId', drm_profile_id);
			client.queue_service_action_call('drm_drmprofile', 'get', kparams);
			if (client.is_multirequest)
				return nil;
			end
			return client.do_queue();
		end

		# Update an existing KalturaDrmProfile object
		# 	 
		def update(drm_profile_id, drm_profile)
			kparams = {}
			client.add_param(kparams, 'drmProfileId', drm_profile_id);
			# Id
			client.add_param(kparams, 'drmProfile', drm_profile);
			client.queue_service_action_call('drm_drmprofile', 'update', kparams);
			if (client.is_multirequest)
				return nil;
			end
			return client.do_queue();
		end

		# Mark the KalturaDrmProfile object as deleted
		# 	 
		def delete(drm_profile_id)
			kparams = {}
			client.add_param(kparams, 'drmProfileId', drm_profile_id);
			client.queue_service_action_call('drm_drmprofile', 'delete', kparams);
			if (client.is_multirequest)
				return nil;
			end
			return client.do_queue();
		end

		# List KalturaDrmProfile objects
		# 	 
		def list(filter=KalturaNotImplemented, pager=KalturaNotImplemented)
			kparams = {}
			client.add_param(kparams, 'filter', filter);
			client.add_param(kparams, 'pager', pager);
			client.queue_service_action_call('drm_drmprofile', 'list', kparams);
			if (client.is_multirequest)
				return nil;
			end
			return client.do_queue();
		end

		# Retrieve a KalturaDrmProfile object by provider, if no specific profile defined return default profile
		# 	 
		def get_by_provider(provider)
			kparams = {}
			client.add_param(kparams, 'provider', provider);
			client.queue_service_action_call('drm_drmprofile', 'getByProvider', kparams);
			if (client.is_multirequest)
				return nil;
			end
			return client.do_queue();
		end
	end

	class KalturaClient < KalturaClientBase
		attr_reader :drm_profile_service
		def drm_profile_service
			if (@drm_profile_service == nil)
				@drm_profile_service = KalturaDrmProfileService.new(self)
			end
			return @drm_profile_service
		end
	end

end
